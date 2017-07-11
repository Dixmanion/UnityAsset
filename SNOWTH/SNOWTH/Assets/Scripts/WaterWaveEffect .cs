using UnityEngine;
using System.Collections;

namespace SNOWTH.UI
{
    public class WaterWaveEffect : MonoBehaviour
    {
        //距离系数  
        public float distanceFactor = 60.0f;
        //时间系数  
        public float timeFactor = -30.0f;
        //sin函数结果系数  
        public float totalFactor = 1.0f;

        //波纹宽度  
        public float waveWidth = 0.3f;
        //波纹扩散的速度  
        public float waveSpeed = 0.3f;

        private float waveStartTime;

        // Use this for initialization
        void Start()
        {

        }

        // Update is called once per frame
        void Update()
        {

        }
    }
}
