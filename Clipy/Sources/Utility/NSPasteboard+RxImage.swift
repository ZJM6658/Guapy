//
//  NSPasteboard+RxImage.swift
//
//  Clipy
//
//  Copyright © 2024 Clipy Project.
//

import Cocoa
import RxSwift
import RxCocoa
import os.log

extension Reactive where Base: NSPasteboard {
    /// 监听剪贴板中纯图片的变化
    /// 当剪贴板只包含图片数据（没有文本、文件等其他类型）时触发
    var imageChange: Observable<NSImage> {
        return Observable<Int>.interval(.milliseconds(500), scheduler: MainScheduler.instance)
            .map { _ in NSPasteboard.general.changeCount }
            .distinctUntilChanged()
            .compactMap { [weak base] _ -> NSImage? in
                let pasteboard = base ?? NSPasteboard.general

                // 获取剪贴板中的所有类型
                guard let types = pasteboard.types else { return nil }

                // 调试：打印所有剪贴板类型
                let typesArray = types.map { $0.rawValue }.joined(separator: ", ")
                NSLog("[Clipy] Clipboard change detected, types: \(typesArray)")

                // 检查是否包含任何图片类型
                let imageTypes = [
                    "public.tiff",
                    "public.png",
                    "public.jpeg",
                    "public.jpeg-2000",
                    "public.gif",
                    "com.adobe.pdf"
                ]

                let hasAnyImage = types.contains { type in
                    imageTypes.contains(type.rawValue)
                }

                // 暂时捕获所有包含图片的剪贴板内容
                guard hasAnyImage else { return nil }

                NSLog("[Clipy] Found image in clipboard, attempting to capture...")

                // 读取图片
                let image = pasteboard.readObjects(forClasses: [NSImage.self], options: nil)?.first as? NSImage
                NSLog("[Clipy] Image captured: \(image != nil)")
                return image
            }
    }
}
