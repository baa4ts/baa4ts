import { Link, Text, View } from '@react-pdf/renderer'
import type React from 'react'

interface Props {
  icono: React.ComponentType
  text: string
  link?: string
}

export const ContactoCv = ({ icono: Icono, text, link }: Props) => {
  return (
    <View
      style={{
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center',
      }}
    >
      <View
        style={{
          alignItems: 'center',
          justifyContent: 'center',
          marginRight: 5,
        }}
      >
        <Icono />
      </View>
      {link ? (
        <Link
          src={link}
          style={[
            { textDecoration: 'none' },
            { fontSize: 9, color: '#6B7280' },
          ]}
        >
          {text}
        </Link>
      ) : (
        <Text style={{ fontSize: 9, color: '#6B7280' }}>{text}</Text>
      )}
    </View>
  )
}
