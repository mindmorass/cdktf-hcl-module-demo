# CDKTF Escape Hatches

Yes! CDKTF supports escape hatches to write raw Terraform HCL when constructs don't support a feature.

## Methods

### 1. `addOverride()` on TerraformElement

Add raw HCL to any resource:

```typescript
import { File } from "@cdktf/provider-local/lib/file";

const file = new File(this, "test", {
  filename: "./test.html",
  content: "<html>...</html>",
});

// Add raw HCL attributes
file.addOverride("some_key", "some_value");
file.addOverride("nested.object.key", { nested: "value" });
```

### 2. `addOverride()` on TerraformStack

Add raw HCL at the stack level:

```typescript
class MyStack extends TerraformStack {
  constructor(scope: Construct, id: string) {
    super(scope, id);

    // Add raw Terraform block
    this.addOverride("resource", {
      some_custom_resource: {
        custom: "value",
      },
    });
  }
}
```

### 3. Raw HCL Blocks

Use `TerraformData`, `TerraformBackend`, etc. for specific block types.

## Common Use Cases

### Adding custom locals

```typescript
// Create a file resource
const file = new File(this, 'test', { ... });

// Add locals block
this.addOverride('locals', {
  my_custom_local: 'value',
  another_local: '${var.something}'
});
```

### Custom providers

```typescript
this.addOverride("provider", {
  custom_provider: {
    config: "value",
  },
});
```

### Modules not yet supported

```typescript
// When a Terraform module doesn't have CDKTF support yet
this.addOverride('module', {
  my_custom_module: {
    source: './my-module',
    variable = {...}
  }
});
```

## Best Practices

1. Use escape hatches sparingly - prefer CDKTF constructs when available
2. Document why you're using escape hatches
3. Consider contributing proper CDKTF support for commonly used patterns
4. Use `cdktf synth --hcl` to verify the generated HCL
