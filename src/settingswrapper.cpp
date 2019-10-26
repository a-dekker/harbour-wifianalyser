#include "settingswrapper.h"

SettingsWrapper::SettingsWrapper(QObject *parent) : QObject(parent)
{
    _settings = new QSettings(QStandardPaths::writableLocation(QStandardPaths::ConfigLocation) +
                              "/harbour-wifianalyser/harbour-wifianalyser.conf", QSettings::NativeFormat);
}

SettingsWrapper::~SettingsWrapper() {
    delete _settings;
}

void SettingsWrapper::setValue(QString key, QString value)
{
    _settings->setValue(key, value);
}

QString SettingsWrapper::value(QString key)
{
    return _settings->value(key).toString();
}
