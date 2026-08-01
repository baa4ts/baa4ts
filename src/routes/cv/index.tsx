import { createFileRoute } from '@tanstack/react-router'
import {
  Document,
  Page,
  PDFViewer,
  StyleSheet,
  Svg,
  Text,
  View,
} from '@react-pdf/renderer'
import { constants } from '#/constants/constants'
import { useIsMounted } from '#/hooks/useIsMounted'
import {
  GithubIcon,
  MailIcon,
  NpmIcon,
  PhoneIcon,
  WebIcon,
} from '#/components/perpage/cv/IconosCV'
import { ContactoCv } from '#/components/perpage/cv/ContactoCv'

export const Route = createFileRoute('/cv/')({
  component: RouteComponent,
  ssr: false,
})

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
    fontSize: 24,
    fontFamily: 'Helvetica-Bold',
    marginBottom: 8,
  },
  divisor: {
    height: 2.5,
    backgroundColor: BLUE,
    width: '100%',
    borderRadius: '15px',
  },

  /**
   * Seccion de contacto
   */
  seccion_contacto: {
    display: 'flex',
    flexDirection: 'row',
    marginTop: 10,
    justifyContent: 'center',
    gap: 15,
  },
})

function RouteComponent() {
  const mounted = useIsMounted()

  if (!mounted) return null

  return (
    <main className="w-screen h-screen">
      <PDFViewer width="100%" height="100%">
        <Document {...constants.CV.metadata}>
          {/* CV */}
          <Page size="A4" style={styles.page}>
            {/* header */}
            <Text style={styles.nombre}>Carlos Guillermo Morales Cardozo</Text>
            <View style={styles.divisor} />

            {/* Seccion contacto */}
            <View style={styles.seccion_contacto}>
              <ContactoCv icono={PhoneIcon} text={'098 061 761'} />
              <ContactoCv
                icono={MailIcon}
                text={'carlosmoralescardozo@tuta.io'}
              />
              <ContactoCv icono={GithubIcon} text={'github/baa4ts'} />
              <ContactoCv icono={WebIcon} text={'baa4ts.is-a.dev'} />
              <ContactoCv icono={NpmIcon} text={'npmjs.com/~baa4ts'} />
            </View>
          </Page>
        </Document>
      </PDFViewer>
    </main>
  )
}
