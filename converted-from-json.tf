# local_file.test-html:
resource "local_file" "test-html" {
    content              = <<-EOT
        <!DOCTYPE html>
        <html>
        <head><title>CDKTF Test</title></head>
                <body>
                  <h1>Success!</h1>
                  <p>This HTML file was created by CDKTF using the local provider.</p>
                  <div style="background: #d4edda; padding: 1rem; border-radius: 5px; margin: 1rem 0;">
                    <strong>CDKTF → Local File Creation Working!</strong>
                  </div>
                </body>
        </html>
    EOT
    content_base64sha256 = "bY1hy1BgF5rt3l/NvCXt9ZQdiOMB3q44tP+xwDiVKng="
    content_base64sha512 = "Wlp2i/5UjjpTeAF2DVsbtjt1szT1vfJ66mU51PjgGvUgXyn6x4Ell7vbNHBF9bmTjmTFAIeQ7bI1ZkdDGk1R6A=="
    content_md5          = "7bf3465556dd0398c6e0f814370dab71"
    content_sha1         = "48aab4d6124a3c8ec454cbc8865cf3664b2df710"
    content_sha256       = "6d8d61cb5060179aedde5fcdbc25edf5941d88e301deae38b4ffb1c038952a78"
    content_sha512       = "5a5a768bfe548e3a537801760d5b1bb63b75b334f5bdf27aea6539d4f8e01af5205f29fac7812597bbdb347045f5b9938e64c5008790edb2356647431a4d51e8"
    directory_permission = "0777"
    file_permission      = "0777"
    filename             = "./output/test.html"
    id                   = "48aab4d6124a3c8ec454cbc8865cf3664b2df710"
}


