class KubesealConvert < Formula
  desc "Tool to import secrets from secret managers (Vault, SecretsMgr) to SealedSecret"
  homepage "https://github.com/EladLeev/kubeseal-convert"
  url "https://github.com/EladLeev/kubeseal-convert/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "1d6e0b012d9d3d6dd54ac535aa092442d50f41faa6047862a3d057eb528593ce"
  license "Apache-2.0"
  head "https://github.com/EladLeev/kubeseal-convert.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65edcb3109d5e3ae727baa7a886ff406447302387f2adf538c64b3be5f55bc5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65edcb3109d5e3ae727baa7a886ff406447302387f2adf538c64b3be5f55bc5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18519463c857da6d1256d3bca66dfe538fc65d2c69c032a4be15855aab05ef48"
    sha256 cellar: :any,                 x86_64_linux:  "4ccd1ba4a2315f384c108aaece42b142d23cf93415cc576d0114a51923f3db7b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"kubeseal-convert", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubeseal-convert --version")

    # Fail on missing credentials locally instead of probing EC2 IMDS or AWS endpoints.
    %w[AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_PROFILE AWS_WEB_IDENTITY_TOKEN_FILE
       AWS_CONTAINER_CREDENTIALS_RELATIVE_URI AWS_CONTAINER_CREDENTIALS_FULL_URI].each { |key| ENV.delete(key) }
    ENV["AWS_REGION"] = "us-east-1"
    ENV["AWS_EC2_METADATA_DISABLED"] = "true"
    ENV["AWS_CONFIG_FILE"] = testpath/"aws-config"
    ENV["AWS_SHARED_CREDENTIALS_FILE"] = testpath/"aws-credentials"

    output = shell_output("#{bin}/kubeseal-convert sm \"fake\" --namespace test-ns --name test-secret 2>&1", 1)
    assert_match "failed to get secret: operation error Secrets Manager", output
    assert_match "get credentials", output
  end
end
