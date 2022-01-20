import {body, ValidationChain} from 'express-validator';
class RequestValidator {


    public static validateContact = (): ValidationChain[] => {
        return [
            body('name').notEmpty().isString(),
            body('dob').notEmpty().isString(),
            body('primary_phone').isString().isMobilePhone("any").notEmpty(),
            body('primary_email').isString().isEmail().notEmpty(),
            body("phones").isArray(),
            body("emails").isArray()
        ]
    }
}
export default  RequestValidator;