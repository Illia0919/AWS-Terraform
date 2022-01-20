import App from './app'
import * as bodyParser from 'body-parser'
import allowCors from "./middlewares/allow-cors";
import errorHandler from "./middlewares/error-handler";
import DefaultController from "./controllers/default-controller";
import ContactController from "./controllers/contacts-controller";

const app = new App({
    port: 5000,
    controllers: [
        new DefaultController(),
        new ContactController()
    ],
    middleWares: [
        bodyParser.json(),
        bodyParser.urlencoded({ extended: true }),
        allowCors,
        errorHandler
    ]
})
app.listen();

export default  app;