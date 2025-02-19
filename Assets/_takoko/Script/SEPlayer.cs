using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SEPlayer : MonoBehaviour
{

    public static SEPlayer Instance;


    [Header("�}�X�^�[����")]
    public float Volume;
    [Header("�����Ɍ��ʉ���")]
    public AudioClip[] SEs;
    [Header("�����Ɍ��ʉ��̉��ʂ�")]
    public float[] SEsVolume;
    [Header("�����Ɍ��ʉ��̔����x����")]
    public float[] SEsDelay;
    [Header("�����Ɍ��ʉ��̍ŏ������Ԋu��")]
    public float[] SEsInterval;
    [Header("������AudioSource��")]
    public AudioSource audioSource;


    private float[] sEsTime;
    private float oldVolume;

    private void Awake()
    {
        Instance = this;
    }

    // Start is called before the first frame update
    void Start()
    {
        sEsTime = new float[SEsInterval.Length];
    }

    // Update is called once per frame
    void Update()
    {
        SECounting();
        VolumeChange();
    }

    public void SE(int i)
    {
        if(sEsTime[i] == 0)
        {
            StartCoroutine("SEPlay",i);
            sEsTime[i] = SEsInterval[i];
        }
    }

    IEnumerator SEPlay(int i)
    {
        yield return new WaitForSeconds(SEsDelay[i]);
        audioSource.PlayOneShot(SEs[i], SEsVolume[i]);
    }


    void SECounting()
    {
        for(int i = 0; i < sEsTime.Length; i++)
        {
            if(sEsTime[i] > 0)
            {
                sEsTime[i] -= Time.deltaTime;
            }
            else
            {
                sEsTime[i] = 0;
            }
        }
    }

    void VolumeChange()
    {
        if(oldVolume != Volume)
        {
            audioSource.volume = Volume;
        }
        oldVolume = Volume;
    }


    public void SEVolume(float i)
    {
        Volume = i;
    }

    public void SEStop()
    {
        audioSource.Stop();
    }
}
