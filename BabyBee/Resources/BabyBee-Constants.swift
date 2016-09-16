//
//  CGConstants.swift
//  BabyBee
//
//  Created by Hawk on 10/09/16.
//  Copyright © 2016 v.vasilenko. All rights reserved.
//

// MARK: - User Defaults
public let CGBabyBirthDateUserDefaults = "babyBirthDate"
public let CGBabyBirthCancelUserDefaults = "isBabyBirthCanceled"
public let CGBabyBirthCancelValue = "canceled"

// MARK: - Segue names
public let CGGamesScreenSegueName = "showGamesScreenSegue"
public let CGContentScreenSegueName = "showContentScreenSegue"

// MARK: - String constants of MainScreen
public let CGBirthAlertTitle = "Дата рождения малыша"
public let CGBirthDayPrefix = "Вашему ребенку уже\n"
public let CGBirthAlertMessage = "Введите дату рождения вашего малыша"
public let CGBirthDatePlaceholder = "Например 14.06.2016"
public let CGMainScreenTitle = "Игры для развития малыша"
public let CGCancelTitle =  "Отмена"
public let CGConfirmTitle = "Подтвердить"
public let CGBirthdayAltText = "Ваш малыш растет вместе с пчелкой BabyBee"
// MARK: - String constans of GamesScreen
public let CGGamesScreenSubtitle = "Выберите игру для вашего малыша"

// MARK: - Analytics Constants
public let CGAnalyticsOpenScreenContentScreenFmt = "Игра %@"
public let CGAnalyticsEventGameSelectedFmt = "Выбрана игра %@"
public let CGAnalyticsEventGroupSelectFmt = "Выбрана категория %@"
public let CGAnalyticsCategoryClick = "Нажатие"
public let CGAnalyticsEventBirthdayCancel = "Cancel - дата рождения"
public let CGAnalyticsEventBirthdayOk = "Ок - дата рождения"

public let CGAnalyticsFirebaseEventNameOpenScreenContentScreen = "openscreen_ContentScreen"
public let CGAnalyticsFirebaseEventGroupSelected = "selected_Group"
public let CGAnalyticsFirebaseEventGameSelected = "selected_Game"
public let CGAnalyticsFirebaseEventBirthdayCancel = "cancel_BirthdayInput"
public let CGAnalyticsFirebaseEventBirthdayOk = "confirm_BirthdayInput"
