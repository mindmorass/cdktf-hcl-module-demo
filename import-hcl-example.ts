import { App, TerraformStack, TerraformHclModule, TerraformOutput } from 'cdktf';
import { LocalProvider } from '@cdktf/provider-local/lib/provider';
import { Construct } from 'constructs';

class ImportHclModuleStack extends TerraformStack {
  constructor(scope: Construct, id: string) {
    super(scope, id);

    new LocalProvider(this, 'local');

    const htmlModule = new TerraformHclModule(this, 'html-module', {
      source: './generated-hcl-module',
      variables: {
        html_files: {
          cdktf_import = {
            filename: './output/cdktf-import-demo.html',
            title: 'CDKTF Importing HCL Module',
            message: 'This HTML was created by CDKTF importing and using the HCL module! This completes the full circle: CDKTF → HCL Module → Import back to CDKTF.'
          }
        }
      }
    });

    new TerraformOutput(this, 'imported-files', {
      value: htmlModule.get('created_files')
    });
  }
}

const app = new App({
  context: {
    cdktfRelativeModules: ['./generated-hcl-module']
  }
});
new ImportHclModuleStack(app, 'ImportHclModuleStack');
app.synth();
