#!/usr/bin/node
const ffmpeg = require('ffmpeg');
const argv = require('yargs');
const walk = require('walk');
const fs = require('fs');
const Jimp = require('jimp');

class Optimizer {
    optimizeDir(dirname) {
        console.log(dirname);
        let walker = walk.walk(dirname);
        const MAX_WORKERS = 7;
        let workerCount = 0;
        let processed = 0;
        let nextCallbacks = [];
        walker.on("file", function (root, fileStats, next) {
            console.log('firing new file job. Worker count:', workerCount);
            let isJpeg = fileStats.name.match(/\.jpe?g/);
            let name = fileStats.name;
            let optimizedFilePath = `./pics/${name}`;
            let sourceFilePath = `${dirname}/${name}`;
            let fileExists = fs.existsSync(optimizedFilePath);
            if (fileStats.type === 'file' && !isJpeg && !fileExists) {
                console.log(name);
                let ff = new ffmpeg(sourceFilePath);
                ff.then(function (video) {
                    const wh = video.metadata.video.resolution;
                    const bitrate = video.metadata.video.bitrate;
                    const maxRes = 1300*750;
                    const targetRes = 1280*720;
                    const currentRes = wh.w * wh.h;

                    const compress = bitrate > 1100;
                    const downscale = currentRes > maxRes;
                    const stripaudio = video.metadata.audio.sample_rate > 0;

                    if (downscale || stripaudio || compress) {
                        console.log(video.metadata);
                        if (downscale) { // resize down to 1280p
                            const scaleRatio = targetRes/currentRes;
                            const targetWidth = Math.floor(wh.w * scaleRatio);
                            video.setVideoSize(`${targetWidth}x?`, true, true);
                        }
                        if (stripaudio) { // strip audio
                            video.setDisableAudio();
                            if (!downscale && !compress) { // If the video is already compressed enough, then lets leave the video untouched.
                                video.addCommand('-c', 'copy');
                            }
                        }
                        //video.setVideoFormat('mp4');
                        if (video.metadata.video.codec == 'h264' && downscale) { // use nvidia encoder for h264 (for speed)
                            video.setVideoCodec('h264');
                            video.addCommand('-c:v', 'h264_nvenc');
                        }
                        if (compress) {
                            video.addCommand('-crf', '15');
                        }
                        workerCount += 1;
                        console.log('processed:', processed);
                        console.log('currentWorkers:', workerCount);
                        if (workerCount < MAX_WORKERS) {
                            next();
                        } else {
                            // save this "next()" callback for later
                            nextCallbacks.push(next);
                        }
                        video.save(optimizedFilePath, (error, file) => {
                            if (!error) {
                                console.log('Video file: ' + file);
                            } else {
                                console.log('ERROR:', error);
                            }
                            workerCount--;
                            processed++;
                            console.log('job finished. Worker Count:', workerCount);
                            if (nextCallbacks.length) { // When a job completes, fire the first saved "next()" callback.
                                (nextCallbacks.shift())();
                            }
                        });

                    } else {
                        if (!fileExists) {
                            fs.createReadStream(sourceFilePath).pipe(fs.createWriteStream(optimizedFilePath));
                        }
                        next();
                    }
                }, function (err) {
                    console.log('Error: ' + err);
                });
            } else if (isJpeg) {
                console.log('isJpeg:', sourceFilePath);
                if (!fileExists) {
                    console.log('optimizing image', sourceFilePath);
                    try {
                        Jimp.read(sourceFilePath).then(function (image) {
                            image.autocrop()
                                 .scaleToFit(1000, Jimp.AUTO)
                                 .quality(85)                 // set JPEG quality
                                 .write(optimizedFilePath); // save
                        }).catch(function (err) {
                            console.error(err);
                        });
                    } catch (e) {
                        console.log('jpg error', e);
                    }
                }
                next();
            } else {
                if (!fileExists) {
                    fs.createReadStream(sourceFilePath).pipe(fs.createWriteStream(optimizedFilePath));
                }
                next();
            }
        });

        walker.on("errors", function (root, nodeStatsArray, next) {
            next();
        });

        walker.on("end", function () {
            console.log("all done");
        });
    }
}
let optimizer = new Optimizer();
optimizer.optimizeDir('./original_pics');
