#ifndef SETTINGSWRAPPER_H
#define SETTINGSWRAPPER_H

#include <QObject>
#include <QSettings>
#include <QStandardPaths>
#include <QString>

#include <QDebug>

class SettingsWrapper : public QObject
{
    Q_OBJECT

public:
    explicit SettingsWrapper(QObject *parent = 0);
    ~SettingsWrapper();

    Q_INVOKABLE void setValue(QString key, QString value);
    Q_INVOKABLE QString value(QString key);

private:
    QSettings *_settings;
};

#endif // SETTINGSWRAPPER_H
