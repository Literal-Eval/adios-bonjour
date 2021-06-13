#include "backend.h"

Backend::Backend(QObject *parent) : QObject(parent)
{
    auto result = QtAndroid::checkPermission("android.permission.WRITE_EXTERNAL_STORAGE");
    if (result == QtAndroid::PermissionResult::Denied)
    {
        QtAndroid::PermissionResultMap resultHash =
                QtAndroid::requestPermissionsSync(
                    QStringList() << "android.permission.WRITE_EXTERNAL_STORAGE");
    }

    result = QtAndroid::checkPermission("android.permission.READ_EXTERNAL_STORAGE");
    if (result == QtAndroid::PermissionResult::Denied)
    {
        QtAndroid::PermissionResultMap resultHash =
                QtAndroid::requestPermissionsSync(
                    QStringList() << "android.permission.READ_EXTERNAL_STORAGE");
    }
}
