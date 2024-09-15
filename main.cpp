#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QFontDatabase>


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // Load the custom font from a file
    int fontId = QFontDatabase::addApplicationFont(":/font/futura.otf");
    if (fontId == -1) {
        qWarning() << "Failed to load font from resource";
    } else {
        QString fontFamily = QFontDatabase::applicationFontFamilies(fontId).at(0);
        QFont customFont(fontFamily);
        // customFont.setPointSize(12);
        qWarning() << fontFamily;

        // Set the application-wide font
        app.setFont(customFont);
    }

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("ClickerTest", "Main");

    return app.exec();
}
