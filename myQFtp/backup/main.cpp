#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QQuickWindow>
#include <QThread>
#include "backend.h"
#include "client.h"
#include "server.h"
#include "files.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    const QUrl url2(QStringLiteral("qrc:/main2.qml"));

    Files::readExtensions();
    Backend backend;
    Client client;
    Server server;

    QQuickStyle::setStyle("Material");
    engine.rootContext()->setContextProperty("Backend", &backend);
    engine.rootContext()->setContextProperty("bClient", &client);
    engine.rootContext()->setContextProperty("bServer", &server);
    engine.rootContext()->setContextProperty("path", QDir::currentPath());

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.load(url);
    engine.load(url2);

    return app.exec();
}
