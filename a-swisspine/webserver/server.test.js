const handleHealth = require('./utils/health');
const handleReverse = require('./utils/reverse');


describe('handleHealth function', () => {
    it('should return status "ok"', () => {
        const result = handleHealth();
        expect(result).toEqual({ status: 'ok' });
    });
});


describe('handleReverse function', () => {
    it('should reverse and toggle case of characters', () => {
        const result1 = handleReverse('SwissPine2024');
        expect(result1).toEqual('4202ENIpSSIWs');

        const result2 = handleReverse('JavaScript');
        expect(result2).toEqual('TPIRCsAVAj');
    });

    it('should handle empty string', () => {
        const result = handleReverse('');
        expect(result).toEqual('');
    });

    it('should handle single character', () => {
        const result = handleReverse('a');
        expect(result).toEqual('A');
    });

    it('should handle special characters', () => {
        const result = handleReverse('@#$%');
        expect(result).toEqual('%$#@');
    });
});
