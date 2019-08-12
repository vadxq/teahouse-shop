<template>
  <div class="clearfix">
    <button class="pickupfilesBox ant-btn ant-btn-default" :id="btnId + '_box'" >
      <a class="pickupfiles" :id="btnId"><a-icon type="upload" /> {{btnText}}</a>
    </button>
  </div>
</template>

<script>
 /* eslint-disable */ 
import qiniu from '../lib/qiniu.js'
import pluploadFun from '../lib/plupload.dev.js'
let plupload = pluploadFun.plupload

export default {
  data() {
    return {
      btnText: '选择上传',
      btnId: 'id' + Math.floor(Math.random() * 100000),
      bucket: "vadxq",
      domain: "https://qnimg.vadxq.com",
      token: '',
    };
  },
  methods: {
    async upload () {
      let res = await this.$http.post('/api/v1/admin/qiniu', { bucket: this.bucket })
      if (res.data.status) {
        this.token = res.data.data
      }
      let that = this
      qiniu.qiniu.uploader({
        runtimes: 'html5,flash,html4', // 上传模式,依次退化
        browse_button: that.btnId, // 上传选择的点选按钮，**必需**
        uptoken: that.token,
        domain: that.domain,
        container: that.btnId + '_box', // 上传区域DOM ID，默认是browser_button的父元素，
        max_file_size: '500mb', // 最大文件体积限制
        flash_swf_url: 'http://jssdk.demo.qiniu.io/js/plupload/Moxie.swf', // 引入flash,相对路径
        max_retries: 3, // 上传失败最大重试次数
        dragdrop: true, // 开启可拖曳上传
        drop_element: that.btnId + '_box', // 拖曳上传区域元素的ID，拖曳文件或文件夹后可触发上传
        chunk_size: '500mb', // 分块上传时，每片的体积
        auto_start: true, // 选择文件后自动上传，若关闭需要自己绑定事件触发上传
        multi_selection: false,
        init: {
          'FilesAdded': function (up, files) {
            console.log(up)
            plupload.each(files, function (file) {
              console.log('bfuploads')
              // 文件添加进队列后,处理相关的事情
            })
          },
          'BeforeUpload': function (up, file) {
            console.log('bfupload')
            that.btnText = '上传中'
            // 每个文件上传前,处理相关的事情
          },
          'UploadProgress': function (up, file) {
            console.log('uploading')
            // 每个文件上传时,处理相关的事情
          },
          'FileUploaded': function (up, file, info) {
            that.btnText = '上传完成'
            var domain = up.getOption('domain')
            that.afterUpload(domain, file.size, info.split('key":"')[1].split('"}')[0])
          },
          'Error': function (up, err, errTip) {
            // common.alertBox(err)
            // 上传出错时,处理相关的事情
          },
          'UploadComplete': function () {
            console.log('上传成功')
            // 队列文件处理完毕后,处理相关的事情
          },
          'Key': function (up, file) {
            // 若想在前端对每个文件的key进行个性化处理，可以配置该函数
            // 该配置必须要在 unique_names: false , save_key: false 时才生效
            var date = new Date()
            var key = 'luckyshop/' + date.getTime() + '.' + file.name
            return key
          }
        }
      })
    },
    afterUpload (domain, size, name) {
      console.log(domain, size, name)
      this.$message.success('上传成功')
      let firpos = name.indexOf('.') + 1
      this.$store.commit('upload/setActiveImg', {
        fileUrl: domain + '/' + name,
        fileName: name.substring(firpos)
      })
    }
  },
  mounted() {
    this.upload()
  }
};
</script>
<style>
.ant-upload-select-picture-card i {
  font-size: 32px;
  color: #999;
}

.ant-upload-select-picture-card .ant-upload-text {
  margin-top: 8px;
  color: #666;
}
</style>