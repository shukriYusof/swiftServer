import Vapor
import FluentPostgreSQL
import Leaf

/// Called before your application initializes.
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
) throws {

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    let leafProvider = LeafProvider()
    try services.register(leafProvider)
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)

    try services.register(FluentPostgreSQLProvider())

    let postgresqlConfig = PostgreSQLDatabaseConfig(
        hostname: "127.0.0.1",
        port: 5431,
        username: "winappdeveloper",
        database: "swift_server",
        password: nil
    )
    services.register(postgresqlConfig)

    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .psql)
    services.register(migrations)
}
