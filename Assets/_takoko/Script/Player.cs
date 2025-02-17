using UnityEngine;

public class Player : MonoBehaviour
{
    [Header("������󂯕t���邩�H")]
    public bool CanMove = false;

    [Header("�}�E�X�ݒ�")]
    public Transform cameraTransform; // �J������Transform
    public float mouseSensitivity = 100f; // �}�E�X���x
    private float xRotation = 0f; // X���̉�]
    private bool cursorLocked = true; // �J�[�\���̃��b�N���

    [Header("�ړ��ݒ�")]
    public float moveSpeed = 5f; // �ړ����x
    private Rigidbody rb; // �v���C���[��Rigidbody

    private bool isGrounded; // �ڒn����p

    void Start()
    {
        rb = GetComponent<Rigidbody>();
        rb.freezeRotation = true; // �������Z�ŉ�]���Ȃ��悤�ɌŒ�
        LockCursor(true);
    }

    void Update()
    {
        if (!CanMove)
            return;

        HandleMouseLook();  // �}�E�X���_�ړ�
        HandleMovement();   // WASD�ړ�
        HandleCursorToggle(); // �J�[�\�����b�N�̐؂�ւ�
    }

    void HandleMouseLook()
    {
        if (!cursorLocked) return; // �J�[�\�������b�N����Ă��Ȃ��Ƃ��͎��_�ړ����Ȃ�

        float mouseX = Input.GetAxis("Mouse X") * mouseSensitivity * Time.deltaTime;
        float mouseY = Input.GetAxis("Mouse Y") * mouseSensitivity * Time.deltaTime;

        xRotation -= mouseY;
        xRotation = Mathf.Clamp(xRotation, -90f, 90f); // �㉺�̎��_�ړ�����

        cameraTransform.localRotation = Quaternion.Euler(xRotation, 0f, 0f); // �J�����̏㉺�ړ�
        transform.Rotate(Vector3.up * mouseX); // �v���C���[�{�̂����E��]
    }

    void HandleMovement()
    {
        if (!cursorLocked) return; // �J�[�\�������b�N����Ă��Ȃ��Ƃ��͈ړ����Ȃ�

        float moveX = Input.GetAxis("Horizontal"); // A/D�L�[�i���E�ړ��j
        float moveZ = Input.GetAxis("Vertical");   // W/S�L�[�i�O��ړ��j

        Vector3 move = transform.right * moveX + transform.forward * moveZ;
        move.y = 0f; // �㉺�ړ����Ȃ��悤�ɂ���
        rb.velocity = new Vector3(move.x * moveSpeed, rb.velocity.y, move.z * moveSpeed); // �ړ�
    }

    void HandleCursorToggle()
    {
        if (Input.GetKeyDown(KeyCode.Escape))
        {
            LockCursor(!cursorLocked);
        }
    }

    void LockCursor(bool lockCursor)
    {
        cursorLocked = lockCursor;
        Cursor.lockState = lockCursor ? CursorLockMode.Locked : CursorLockMode.None;
        Cursor.visible = !lockCursor;
    }
}
