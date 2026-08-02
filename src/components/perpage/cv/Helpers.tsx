import { Text, View } from '@react-pdf/renderer'

export const Bullet = ({ text }: { text: string }) => (
  <View style={{ flexDirection: 'row', marginBottom: 2.5, paddingRight: 4 }}>
    <Text style={{ width: 10, fontSize: 9 }}>•</Text>
    <Text
      style={{ flex: 1, fontSize: 8.7, lineHeight: 1.35, color: '#6B7280' }}
    >
      {text}
    </Text>
  </View>
)

export const SubseccionTitulo = ({ text }: { text: string }) => (
  <Text
    style={{
      fontSize: 9.5,
      fontFamily: 'Helvetica-Bold',
      marginTop: 8,
      marginBottom: 3,
      color: '#111111',
    }}
  >
    {text}
  </Text>
)

export const SeccionHeader = ({ title }: { title: string }) => (
  <View
    style={{
      borderBottomWidth: 2,
      borderBottomColor: '#2F2FE4',
      borderBottomStyle: 'solid',
      alignSelf: 'flex-start',
      paddingBottom: 1.5,
      marginBottom: 6,
    }}
  >
    <Text
      style={{
        fontSize: 13,
        fontFamily: 'Helvetica-Bold',
      }}
    >
      {title}
    </Text>
  </View>
)
