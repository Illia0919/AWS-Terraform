import {NextFunction, Request, Response, Router} from 'express';
import requestResponseLogger from '../middlewares/request-response-logger';
import * as bodyParser from 'body-parser';
import RequestValidator from "../utilities/request-validator";
import {validationResult} from 'express-validator';
import {v4} from 'uuid';
import {DatabaseManagerService} from "../services/database-manager-service";
import {BadInputError} from '../models/errors/domain-error';
import asyncWrapper from "../middlewares/async-wrapper";
import Contact from "../models/contact";

class ContactController {

    public router = Router();
    public path = "/api/contacts";
    private dbService: DatabaseManagerService<Contact>;

    constructor() {
        this.router.use(bodyParser.json());
        this.router.use(requestResponseLogger);
        let tableName = process.env.DOCUMENTS_TABLE as string;
        this.dbService = new DatabaseManagerService<Contact>(tableName);
        this.initRoutes();
    }

    private initRoutes() {
        this.router.post('/', RequestValidator.validateContact(), this.createContact);
        this.router.get('/:id', this.getContact);

    }

    createContact =  asyncWrapper(async (req: Request, res: Response, next: NextFunction) => {
        const validationResults = validationResult(req);
        if (!validationResults.isEmpty()) {
            let error = new BadInputError(validationResults.array());
            res.status(400).json(error);
        }

        let contact = new Contact();
        contact.contact_id = v4()
        contact.name = req.body.name;
        contact.dob = req.body.dob;
        contact.emails = req.body.emails;
        contact.phones = req.body.phones;
        contact.primary_email = req.body.primary_email;
        contact.primary_phone = req.body.primary_phone;

        await this.dbService.create(contact);

        res.status(200).json(contact);
    });



    getContact = asyncWrapper(async (req: Request, res: Response) => {
        const {id} = req.params;
        let contact = await this.dbService.getById(id).catch(reason => {
            return res.status(400).json(reason);
        });
        res.status(200).json(contact);
    });
}

export default ContactController;