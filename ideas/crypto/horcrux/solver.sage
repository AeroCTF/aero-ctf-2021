#!/usr/bin/env sage

from gmpy2 import next_prime
from itertools import permutations
from collections import namedtuple
from Crypto.Cipher import AES


p = 0x27266a1284b761f793a529b9664693a6b1db36864a8664898d98d8010ec51afffaef2d1c79ab2078c1e0b289a1719d34b0a081ca325ba2b367017ee8e0824aaa9488409e76e923d0f0fc917ddfc1b0534e93a74246405dadfd1683f0dc31682eed0fa6b95fc235c845e16d2ef40463b7e746668dad82981fc4e05933aca410c65b36f89738f7d97502f6626c38f595338f3864638d8613fb74c16b63f3969a49ebd103ef354ed756c3cd5e67f1d2dbe5acdbc088bd6c1d503acef4ec59e4a09efac4729ca796ad25217fe74e7a0c7ef5a3e1fcd9eb9288fb89e842ef0b16642f7e84e27df4bcb623726e2c44ef46be07f9b5a5f92fe2c77d0de79fa6d46193b064207125d8935c2ff04f63e2f858e98d2518077dc58e13307f01d65ae953efd70980f3aeed320b7a6b66eb0c578dc3f05d426f412c4e3c7a9bcc68f27fe236fde41400371a39f53828824f5de3d5902cd3e7dcaee58b89c1a234188e391d412e7bc598d4f10b2bcb26aab7cd09194e80be046022ee8471
F = GF(p, proof=False)

Point = namedtuple('Point', ['x', 'y'])

G = Point(
    F(0x4f69c16e493693a9342b7b9bb0ae42d0e7425996151c631a5620ad4d7ed372d285f04df82975a379080af08322fd927cf8ea9702f4533b5981351dd12358ca61c6e34af3f902b13d2981cae7cd2416e910bfe2c90f3b64c02bf933b1d11ff8ee384f5b507d9a0b1be38b15e7db3ba700ed32122a0163ec66530911fe142e098187771f5a248627a1709800069d402c1a61a17bd053ff6541f981898df6670420b0f3ea6ebd6d01d24f6fe9e3091a7c36df0c1ad7596e8ae090c54528385422911ff8e1dc201ab56844bc92acabc495c442104de5c34a5fe6661b7213500f4ccef6e76b94c34d60772fcf0c1250e66812d85efcda4b323250f740d0d57d40697fedae0bdbaceb0582cd7c82a27610e7f9fba5ac8f84e006d034dcf481f2dc9338acabd51c28afc1b4fc1d0cd7c1cd5ad21109e8708e9458e5301868c68920ab1aefb1e9184383002e6c893f1793443f8388f3f1b6e1f4ecaecb4cf000f57f677156efdacb20d60a35b8337ee416957aadffdc889dce487),
    F(0x2393c955e5f44ab3ac052dafd83554222728393b8fd20630f3c4f122d8c86d872a7b692b3782f12a6e57352c46328f85fad2d73eaccfcbf7beb47f97da2148c4f3fc7d6751bf66569c97a64f732e7cc71767ba11b1419732035c0285ff6973fba230a3d315fba7820855208e07e6fc5bc4b2cc3868aacde3b8e9b2075bfe861b2ebccd9b6c836d85dc319290263961344d348fe8faa0aa3ebca76fe514a7b7ba313a8200727b22a8714f8bba9e5ec2c549e5bfb5857c050d1ff0471d4b01426c2ee583a7d4b6c30df5ad2d9a6902f574416f8d55ed192b29d521e5d23a54e5062400b539468dca9aa3dc558feac63c88fc696d42434ad9a83551e6860aeb6a4d84ca80713387fa8c56a1e473a82af63ec03a71202aba0ae46fb9a97132f4c92d332327e2c11b79008586b22d92d60c3155e88b5e1f9c193b363ca28f0990400afb6e8148458708b89c6023c0d5ebb746bcd754fe37a84ee4dea6baa273b2ef31a864e9586f01bae855cc0d6f6055b2546b2a918664bdb6)
)


def ec_neg(P):
    return Point(P.x, -P.y)


def ec_double(P, a):
    l = (3 * P.x^2 + a) / (2 * P.y)

    xR = l^2 - 2 * P.x
    yR = l * (P.x - xR) - P.y

    return Point(xR, yR)


def ec_add(P, Q):
    l = (Q.y - P.y) / (Q.x - P.x)

    xR = l^2 - P.x - Q.x
    yR = l * (P.x - xR) - P.y
    
    return Point(xR, yR)


def get_congruence_expr(U1, U2, G):
    P.<xU1, yU1, xU2, yU2, xG, yG> = PolynomialRing(ZZ)
    
    # U1 = (s / 2 - 1) * G = s*G / 2 - G
    # U2 = (s / 2 / 2 - 1) * G = s*G / 4 - G
    # 
    # s*G / 2 = U1 + G
    # 
    # U2 = (U1 + G) / 2 - G
    # 2 * U2 = U1 - G
    # U1 - U2 = U2 + G
    
    x_left, y_left = ec_add(
        Point(xU1, yU1),
        ec_neg(Point(xU2, yU2))
    )

    x_right, y_right = ec_add(
        Point(xU2, yU2), 
        Point(xG, yG)
    )

    x_expr = (x_left - x_right).numerator()
    y_expr = (y_left - y_right).numerator()

    substitute = {
        xU1: U1.x,
        yU1: U1.y,
        xU2: U2.x,
        yU2: U2.y,
        xG: G.x,
        yG: G.y
    }

    return Point(
        x_expr.change_ring(F).substitute(substitute),
        y_expr.change_ring(F).substitute(substitute)
    )


def get_coefficients(expr):
    coefficients = dict()
    
    for monomial in expr.monomials():
        coefficient = expr.monomial_coefficient(monomial)

        if coefficient in coefficients:
            coefficients[coefficient] += monomial
        elif -coefficient in coefficients:
            coefficients[-coefficient] -= monomial
        else:
            coefficients[coefficient] = monomial
    
    return dict((y, x) for x, y in coefficients.items())


def get_delta_powers(monomials):
    powers = dict((monomial, max(x.degree() for x in monomial.monomials())) for monomial in monomials)
    max_power = max(powers.values())

    result = dict()

    for monomial, power in powers.items():
        if monomial == 1:
            result[monomial] = max_power - 1
        else:
            result[monomial] = max_power - power

    return result


def get_coefficients_vector(coefficients, monomials, delta, delta_powers):
    result = []

    for monomial in monomials:
        result.append(coefficients.get(monomial, 0) / delta^delta_powers.get(monomial, 0))

    return vector(ZZ, result + [p])


def recover_errors(W1, W2, delta):
    P.<e1, f1, e2, f2> = PolynomialRing(F)

    x_expr, y_expr = get_congruence_expr(
        Point(W1.x + e1, W1.y + f1),
        Point(W2.x + e2, W2.y + f2),
        G
    )

    x_coefficients, y_coefficients = map(get_coefficients, (x_expr, y_expr))
    
    all_monomials = list(set(x_coefficients.keys()) | set(y_coefficients.keys()))
    all_monomials.sort(key=lambda monomial: (monomial.degree(), str(monomial)))

    delta_powers = get_delta_powers(all_monomials)
    n = len(all_monomials) + 1

    M = matrix \
            .identity(ZZ, n) \
            .augment(get_coefficients_vector(x_coefficients, all_monomials, delta, delta_powers)) \
            .augment(get_coefficients_vector(y_coefficients, all_monomials, delta, delta_powers)) \
            .augment(vector(ZZ, n)) \
            .stack(vector(ZZ, [0] * (n + 2) + [1]))

    B = M.LLL()

    for row in B.rows():
        if row[0] != 0:
            return row[1:] / row[0]


def long_to_bytes(n):
    n = int(n)
    return n.to_bytes((n.bit_length() + 7) // 8, 'big')


def get_possible_keys(values, errors, delta):
    for permutation in permutations(errors):
        key_parts = [(value + error) ^^ value for value, error in zip(values, permutation)]
        key = b''.join(long_to_bytes(part % delta) for part in key_parts)
        
        yield key


def main():
    delta = 1 << 32

    W1 = Point(
        F(0x2700ff7abe81679c770d3171c993c55da4a47cda3360e33d2b763e65517f307a39d401a256ee0634f3f1c6c244aad34422dccfe9ebd1803339972095eb2b0a57c82ee0db9ba94365cfb5270c4924c5c1ec00db2aff529aa923b113d2ca8ad6a6774fb7c655cd101ea63bc5a6ea0261f8da82d455219c7584d7de0757b2fda627c4684d3bac8f899c24178c7e0ecef6c226892b86043d3853cdb777889ce2901d8496bf0232dd000208eb2ce77e953c478551b1112ebf4b02f0086726210a50dc20ac08eb15d846084f9324b4f1f5ec73e3ef7e4a5207e04ebb866f731201e5f626084d1b61c158cfd0fdbaae8b8dd23ba599689c74a790933a3e77daa1c95fbde63b74381aff2b98f41cfebb7f1b220a4f2e8c3361734d7bd6648c720efc0a5f978917d8b84b4764e416762884f00104981e62d876d460bd8c1095cd755d8f31c5377e5ef935da77ff82e823b49d817a1f91bd4d155306173eb07efa4567d362e1cddbf0483873d5efc9286c36a58e5b3d995f3d01ca60),
        F(0x1bf9a696ef976644dd903fb148892044fe65dd16bf12966a6b6e43be4b3b52aaa348a76ed5a53bbb400a366c59c96cf88a9c6a713273a722c0c8cd6f42b7c6f5e1911d2d323780bce65be80eef4d375dd3425a9ff832e4166765c7687aaf3c6f3c1ae7c561c46c49f0075bb68d48b95be5fd2c94996a42ba255eb638ae5ce449064cc81831f2239dbb93f4944693ee42a507dc2878988928dc9ed5bb5cb3b3eba9ac414b4171e505d285edaf02d13c0748e47b17a498cb0c15883977a11cde98995a022999a555fb3f1a3b9226dc4122f3db6c86036b1b0e6ada10b23b8c89ddb590f2186191c0f1148a04a8e35c905d4053943554c58e8f0e2ccac42c2307532e2b8f55b74fccb8ab24a977c557d10bd7c8621bef3e7f326d00c3ff28a52ee85ec61bb8aef14f67ac80da5885a93f2840a5e44d9800b0352163667ba851bb15c4083955e1fba5cd9d6e7bf103a2bbb0fbc868136cf2871815762514c691e6352af18324d1ccdc21da3e1c4c6aa771aa9fccf343ad64b8)
    )

    W2 = Point(
        F(0xa439486ae1dbd96ca0796947609757b9dc068d8ed8287f98261c0c77e0940d29e25d27e16b97bc6983be505b8295886a5e880664ecb2d9161036f5beb1dbdac08da0cc2797d574e0feac67bbcb43275ab9e9d936aa17fd9a0a13a2f95e111b5e0893c4d4c3afae3bfa4a60fc5d0673215dd876b8bc960fc765401135dc708562cbeb572fcefaef1fef51782f6e0b495c0799cf89a9f47ffec11b0e780fb41e80d75681f7c9dd5fbf5e93e1dcda8091ca6a84de5b82b3abc9194913119e429781c12c11ebc6b6e80c01683344319879dec8fe59dd2f9c5b7b6e5e211153ae3b5fd161edae59777f3e76ecdeaef518495e512119451c6a97a8f471c4349ba7df8c3e9c1ba67f7a4fef57551d58b8c87607dc830c8074eec50841a1e365be90b528e4f39b8e19e7617191ac5118bb1abc44739d65384d915cb72e226122965ebae1581f55ecb12e523b0e904b3c0a1b26cf506ca030a68fe40d34c0912272277cd0d605ab057dbb5423cca28629661ad163232e766e80949),
        F(0x29cfc760529c48d68bc086a5b4403f1d4446db04abe243c99baf659b5e67cd6cdac9a658f273f4c682b9e13dda72aaa1ede42c69c98640f2fc58eabeef143a65334e4a236a6e72a157d92ab1a541c9bcf7d953b386a40d68880312ed1e900f6ba481bf134515f5a4c245a0d924db0e5105fc44fae71fc991df85219403ba5d48f68d5d91151f8411b4cbb6971bd63030b523989fa7ec94c14136ac712d4e91eca4c930d79caab7c328043c762917c4b3f868ce037cae9f19a579272c6b13ca8c19d349f5777bf6ac9c078d8472c92582daf96b30d4f7b8fdc004a36b792c133e2b6511956480892636ea91a3361afd8a3afbe3a5bf889feb5a5dc143f5a917347591634218066f2f71b36afd5257f6637152ac9a0965daa881ddc86ca8a8545b255cbb14e7738297a55c7428d9a0e79dee37f801fc1d49d205be809e0cd1b8a1b9d1d5b1b1a9ae98e7c564718cb17d10a3dd01c2914d7bb96c45a4fc942c2ed628354882464407c3208938282471aa2b8016e46c998e4)
    )

    ciphertext = bytes.fromhex('b6094505efd8e2824e8cc8698e5e68e3b2c306a2c8179fbefbfb7d2fc1a0cfb921a89f94dde88b04e655ad87d15efcc7466af652d6a330e92babceca94be63b126702153ad83d24baf7d8848bb71202771a2d80870fbd17462a715906dfc63bc')
    
    errors = list(map(int, recover_errors(W1, W2, delta)[:4]))
    values = list(map(int, (W1.x, W1.y, W2.x, W2.y)))

    for key in get_possible_keys(values, errors, delta):
        cipher = AES.new(key=key, mode=AES.MODE_ECB)
        flag = cipher.decrypt(ciphertext)

        if flag.startswith(b'Aero{'):
            print(flag.strip(b'\x00'))


if __name__ == '__main__':
    main()
