from ctypes import windll

SwapMouseButton = windll.user32.SwapMouseButton

prev_state = SwapMouseButton(0)

SwapMouseButton(int(not prev_state))
