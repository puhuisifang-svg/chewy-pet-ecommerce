import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useCheckoutStore = defineStore('checkout', () => {
  const address = ref(null)
  const deliveryMethod = ref(null)
  const orderId = ref(null)

  function setAddress(addr) { address.value = addr }
  function setDeliveryMethod(method) { deliveryMethod.value = method }
  function setOrderId(id) { orderId.value = id }
  function reset() {
    address.value = null
    deliveryMethod.value = null
    orderId.value = null
  }

  return { address, deliveryMethod, orderId, setAddress, setDeliveryMethod, setOrderId, reset }
})
