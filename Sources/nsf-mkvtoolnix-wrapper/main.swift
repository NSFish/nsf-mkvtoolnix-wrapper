import Foundation
import ArgumentParser


enum NSFMKVError: Error {
    case unknownOperation
    case unknownTrackType
    case noFiles
    case dummy
}
// nsf-mkvtoolnix-wrapper remove subtitles --all -dir xxx\xxx\xxx
// nsf-mkvtoolnix-wrapper remove subtitles -language jpn --only-keep-specified


NSFMKVToolNixWrapper.main()
