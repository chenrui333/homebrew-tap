class Protodep < Formula
  desc "Collect necessary .proto files (Protocol Buffers IDL) and manage dependencies"
  homepage "https://github.com/stormcat24/protodep"
  url "https://github.com/stormcat24/protodep/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "0dd26260f604955209c856c179e225cdc956fe7ba7f92f33a4f1d5d8d86d30aa"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ffb701c7fc8d041d2e20990b3a7b6d891d8ea31110b7d8dbff84ed60786b43e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00de15ca4cce4708369b303681146e21df1d79d84ff8a301e0b6782a1fafca8f"
    sha256 cellar: :any_skip_relocation, ventura:       "5403f3af0bd42e59feab3a238b1544faae26ef9d41d79414da2d4502a27ee299"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74b100e1dcdd457a8a19e52205ec3c5b3a31bd589e5afdadbf2293a40f52b5a1"
  end

  depends_on "go" => :build

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
    if OS.mac?
      output = shell_output("#{bin}/protodep up", 255)
      assert_match "unable to find any valid known_hosts file", output
    else
      output = shell_output("#{bin}/protodep up 2>&1", 2)
      assert_match "error creating SSH agent", output
    end
  end
end
