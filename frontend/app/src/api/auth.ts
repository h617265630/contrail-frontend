// Use a relative import to avoid editor/tooling alias resolution issues in some setups
import request from '../utils/request';


export interface RegisterParams{
    username: string
    email: string
    password: string
}

export function register(data: RegisterParams){
    return request.post('/users/register',data)
}   

export interface LoginParams {
    username: string
    password: string
}   

export function login(data: LoginParams){
    // /users/login uses OAuth2PasswordRequestForm, requires x-www-form-urlencoded
    // Use globalThis to avoid TS compile errors in environments where DOM lib isn't available
    const form = new (globalThis as any).URLSearchParams()
    form.set('username', data.username)
    form.set('password', data.password)
    return request.post('/users/login', form, {
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
    })
}