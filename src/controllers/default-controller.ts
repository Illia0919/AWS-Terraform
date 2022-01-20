import {Request, Response, Router}  from 'express';

class DefaultController {
    public path = '/'
    public router = Router()

    constructor() {
        this.initRoutes()
    }

    public initRoutes() {
        this.router.get('/', this.home)
    }

    home = (req: Request, res: Response) => {
        res.send('Contact API!');
    }
}

export default DefaultController