import Vapor

final class UserController{
    
    //view with users
    func list(_ requset: Request) throws -> Future<[User]> {
        return User.query( on: requset).all()
    }
    //function create a new user
    func create(_ request: Request) throws -> Future<User> {
        return try request.content.decode(User.self).flatMap{ user in
            return user.save(on: request)
        }
    }
    //function update user
    func update(_ request: Request) throws -> Future<User>{
        return try request.parameters.next(User.self).flatMap{ user in
            return try request.content.decode(User.self).flatMap{ newUser in
                user.username = newUser.username
                return user.save(on: request)
            }
        }
    }
    //function delete user
    func delete(_ request:Request) throws -> Future<HTTPStatus>{
        return try request.parameters.next(User.self).flatMap{ user in
            return user.delete(on: request)
        }.transform(to: .ok)
    }
    
}
