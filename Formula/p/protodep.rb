class Protodep < Formula
  desc "Collect necessary .proto files (Protocol Buffers IDL) and manage dependencies"
  homepage "https://github.com/stormcat24/protodep"
  url "https://github.com/stormcat24/protodep/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "0dd26260f604955209c856c179e225cdc956fe7ba7f92f33a4f1d5d8d86d30aa"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4599404ec2475eab524bad3a72ac333008efe7d22bb5e0dfc07e3bb7ece22160"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4599404ec2475eab524bad3a72ac333008efe7d22bb5e0dfc07e3bb7ece22160"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcd25f665b7d84cd2a64313e99baf3b3c6ddbcddbded01cb81acf1cbb4ca0f8a"
    sha256 cellar: :any,                 x86_64_linux:  "34708a75cb9a3b49e5de27e80d8d2bade24f73ff9b97ada6c2212b0e83019b8c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/stormcat24/protodep/version.version=#{version}
      -X github.com/stormcat24/protodep/version.gitCommit=#{tap.user}
      -X github.com/stormcat24/protodep/version.gitCommitFull=#{tap.user}
      -X github.com/stormcat24/protodep/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"protodep", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/protodep version")

    (testpath/"proto").mkpath
    (testpath/"protodep.toml").write <<~EOS
      proto_outdir = "./proto"

      [[dependencies]]
      target = "github.com/google/protobuf/examples"
      branch = "master"
    EOS

    # default to use ssh-agent, https://github.com/stormcat24/protodep/blob/master/README.md#attention-changes-from-010
    # without an agent socket it fails before any network access
    ENV.delete("SSH_AUTH_SOCK")
    output = shell_output("#{bin}/protodep up 2>&1", 2)
    assert_match "error creating SSH agent", output
  end
end
