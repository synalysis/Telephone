//
//  DefaultUseCaseFactory.swift
//  Telephone
//
//  Copyright (c) 2008-2016 Alexey Kuznetsov
//  Copyright (c) 2016 64 Characters
//
//  Telephone is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  Telephone is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//

import UseCases

final class DefaultUseCaseFactory {
    fileprivate let repository: SystemAudioDeviceRepository
    fileprivate let defaults: KeyValueUserDefaults

    init(repository: SystemAudioDeviceRepository, defaults: KeyValueUserDefaults) {
        self.repository = repository
        self.defaults = defaults
    }
}

extension DefaultUseCaseFactory: UseCaseFactory {
    func makeUserDefaultsSoundIOLoadUseCase(output: UserDefaultsSoundIOLoadUseCaseOutput) -> ThrowingUseCase {
        return UserDefaultsSoundIOLoadUseCase(repository: repository, defaults: defaults, output: output)
    }

    func makeUserDefaultsSoundIOSaveUseCase(soundIO: PresentationSoundIO) -> UseCase {
        return UserDefaultsSoundIOSaveUseCase(soundIO: soundIO, defaults: defaults)
    }

    func makeUserDefaultsRingtoneSoundNameSaveUseCase(name: String) -> UseCase {
        return UserDefaultsRingtoneSoundNameSaveUseCase(name: name, defaults: defaults)
    }
}
