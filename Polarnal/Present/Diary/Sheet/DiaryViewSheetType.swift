//
//  DiaryViewSheetType.swift
//  Polarnal
//
//  Created by 최승범 on 12/4/24.
//

import Foundation
import EnumHelper

@IdentifiableEnum
enum DiaryViewSheetType {
    case addFolder(Folder?)
    case editFolder(Folder)
    case photo
}
