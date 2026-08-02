import {
  Document,
  Link,
  Page,
  StyleSheet,
  Text,
  View,
} from '@react-pdf/renderer'
import { constants } from '#/constants/constants'
import {
  GithubIcon,
  MailIcon,
  NpmIcon,
  PhoneIcon,
  WebIcon,
} from '#/components/perpage/cv/IconosCV'
import { ContactoCv } from '#/components/perpage/cv/ContactoCv'
import {
  Bullet,
  SeccionHeader,
  SubseccionTitulo,
} from '#/components/perpage/cv/Helpers'

const BLACK = '#111111'
const BLUE = '#2F2FE4'
const GRAY = '#6B7280'

const styles = StyleSheet.create({
  page: {
    paddingTop: 34,
    paddingHorizontal: 36,
    paddingBottom: 36,
    fontFamily: 'Helvetica',
    fontSize: 9,
    color: BLACK,
  },

  nombre: {
    fontSize: 22,
    fontFamily: 'Helvetica-Bold',
    marginBottom: 8,
  },

  divisor: {
    height: 2.5,
    backgroundColor: BLUE,
    width: '100%',
    borderRadius: 15,
  },

  // Contacto
  seccion_contacto: {
    flexDirection: 'row',
    marginTop: 10,
    justifyContent: 'center',
    gap: 15,
  },

  // Texto plano (PERFIL, descripciones)
  plainText: { fontSize: 8.7, lineHeight: 1.4, color: BLACK },

  // Proyectos
  proyecto: { marginTop: 6, flexDirection: 'column' },
  proyecto_nombre: {
    fontSize: 10,
    fontFamily: 'Helvetica-Bold',
    marginBottom: 2,
  },
  proyecto_desc: { fontSize: 8.7, lineHeight: 1.35, color: GRAY },
})

export const GenerarCV = () => {
  return (
    <Document {...constants.CV.metadata}>
      <Page size="A4" style={styles.page}>
        {/* Nombre */}
        <Text style={styles.nombre}>{constants.USERNAME}</Text>
        <View style={styles.divisor} />

        {/* Contacto */}
        <View style={styles.seccion_contacto}>
          <ContactoCv
            icono={PhoneIcon}
            text="098 061 761"
            link="tel:+59898061761"
          />
          <ContactoCv
            icono={MailIcon}
            text="carlosmoralescardozo@tuta.io"
            link="mailto:carlosmoralescardozo@tuta.io"
          />
          <ContactoCv
            icono={GithubIcon}
            text="github/baa4ts"
            link="https://github.com/baa4ts"
          />
          <ContactoCv
            icono={WebIcon}
            text="baa4ts.is-a.dev"
            link="https://baa4ts.is-a.dev/"
          />
          <ContactoCv
            icono={NpmIcon}
            text="npmjs.com/~baa4ts"
            link="https://www.npmjs.com/~baa4ts"
          />
        </View>

        {/* PERFIL */}
        <View style={{ marginTop: 16 }}>
          <SeccionHeader title="PERFIL" />
          <View style={{ paddingHorizontal: 15, marginTop: 4 }}>
            <Text style={styles.plainText}>{constants.BIO}</Text>
          </View>
        </View>

        {/* PROYECTOS */}
        <View style={{ marginTop: 14 }}>
          <SeccionHeader title="PROYECTOS" />
          <View style={{ paddingHorizontal: 15 }}>
            {constants.proyectos.map((m, i) => (
              <View key={i} style={styles.proyecto}>
                <View
                  style={{
                    flexDirection: 'row',
                    gap: 2,
                    alignItems: 'center',
                  }}
                >
                  <Text style={styles.proyecto_nombre}>{m.name} </Text>
                  <Text>{'- '}</Text>
                  <Link
                    style={{ textDecoration: 'none', color: BLACK }}
                    src={m.repolink}
                  >
                    {m.repo}
                  </Link>
                </View>
                <Text style={styles.proyecto_desc}>{m.descripcion}</Text>
                <Text style={[styles.proyecto_desc, { marginTop: 2 }]}>
                  Tecnologías: {m.tecnologias.join(', ')}
                </Text>
              </View>
            ))}
          </View>
        </View>

        {/* FORMACION */}
        <View style={{ marginTop: 14 }}>
          <SeccionHeader title="FORMACION" />
          <View style={{ paddingHorizontal: 15 }}>
            <SubseccionTitulo text="Tec. en Redes y Software — En curso - Polo Educativo Tecnológico Melo / IAE" />
            <Bullet text="Cisco Packet Tracer" />
            <Bullet text="Linux, Docker y BIND9 (DNS)" />
            <Bullet text="Backend con Express.js y Node.js" />
            <Bullet text="TypeScript" />
            <Bullet text="MySQL y diseno de bases de datos" />

            <SubseccionTitulo text="Desarrollo Web / Mobile — React y React Native - UDEMY - DevTalles" />
            <Bullet text="Desarrollo de aplicaciones web con React (Hooks, Context API), gestion de estado con Zustand, estilos con Tailwind CSS y queries con TanStack Query." />
            <Bullet text="React Native con Expo — desarrollo mobile multiplataforma, publicacion en App Store y Play Store." />

            <SubseccionTitulo text="Habilidades digitales para la empleabilidad - INEFOP" />
            <Bullet text="Trabajo colaborativo con Microsoft Teams." />
            <Bullet text="Procesamiento de datos con Excel." />
            <Bullet text="Introduccion a Inteligencia Artificial Generativa y prompt engineering." />
          </View>
        </View>
      </Page>
    </Document>
  )
}
