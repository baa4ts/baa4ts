import { Text, View } from '@react-pdf/renderer'
import type React from 'react'

interface Props {
  icono: React.ComponentType
  text: string
}

export const ContactoCv = ({ icono: Icono, text }: Props) => {
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
      <Text style={{ fontSize: 9, color: '#6B7280' }}>{text}</Text>
    </View>
  )
}
