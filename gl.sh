#!/bin/sh

flutter gen-l10n --template-arb-file=intl_en.arb
flutter pub run intl_utils:generate