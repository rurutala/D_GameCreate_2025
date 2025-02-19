using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class MessageManager : MonoBehaviour
{
    //[Header("��������Ă��郁�b�Z�[�W�̔ԍ�")]
    public int NowMessage;

    //[Header("�����ɓo��l���̖��O��������e�L�X�g���A�^�b�`")]
    public Text CharacterNameText;
    //[Header("�����ɓo��l���̃Z���t��������e�L�X�g���A�^�b�`")]
    public Text CharacterMessageText;
    //[Header("�����ɓo��l���̖��O��������e�L�X�g�̔w�i���A�^�b�`")]
    public GameObject CharacterBackGround;
    //[Header("�����ɓo��l���̖��O��ݒ�B���Ԃ�NowMessage�ŊǗ������")]
    public string[] Character;
    //[Header("�����ɓo��l���̃Z���t��ݒ�B���Ԃ�NowMessage�ŊǗ������")]
    public string[] CharacterMessage;

    [Header("ここにメッセージがいっぱい")]
    public MessageClass[] Messages;

    //[Header("������Player���A�^�b�`")]
    public Player player;

    private bool isTyping = false;
    private Coroutine typingCoroutine;

    void Start()
    {
        NowMessage = 0;
        DisplayMessage();
    }

    void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            MessageNext();
        }
    }

    public void MessageNext()
    {
        if (isTyping)
        {
            StopCoroutine(typingCoroutine);
            CharacterMessageText.text = CharacterMessage[NowMessage];
            SEPlayer.Instance.SEStop();
            isTyping = false;
        }
        else
        {
            NowMessage++;
            if (NowMessage < Messages.Length)
            {
                DisplayMessage();
                SEPlayer.Instance.SE(0);
            }

            if(NowMessage ==  Messages.Length)
            {
                player.CanMove = true;
            }
        }
    }

    void DisplayMessage()
    {
        CharacterNameText.text = Messages[NowMessage].CharacterName;
        if (Messages[NowMessage].CharacterName == "")
        {
            CharacterBackGround.SetActive(false);
        }
        else
        {
            CharacterBackGround.SetActive(true);
        }
        typingCoroutine = StartCoroutine(TypeMessage(Messages[NowMessage].Message));
    }

    IEnumerator TypeMessage(string message)
    {
        isTyping = true;
        CharacterMessageText.text = "";
        foreach (char letter in message.ToCharArray())
        {
            CharacterMessageText.text += letter;
            yield return new WaitForSeconds(0.025f);
        }
        SEPlayer.Instance.SEStop();
        isTyping = false;
    }
}

[System.Serializable]
public class MessageClass{
    public string CharacterName;
    [TextArea] public string Message;
}
