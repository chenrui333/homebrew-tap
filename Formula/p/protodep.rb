class Protodep < Formula
  desc "Collect necessary .proto files (Protocol Buffers IDL) and manage dependencies"
  homepage "https://github.com/stormcat24/protodep"
  url "https://github.com/stormcat24/protodep/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "0dd26260f604955209c856c179e225cdc956fe7ba7f92f33a4f1d5d8d86d30aa"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1fd211e495e92aac44aecbae393438c951ef3366fcefbe71e8d8b746b55daeeb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fd211e495e92aac44aecbae393438c951ef3366fcefbe71e8d8b746b55daeeb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fd211e495e92aac44aecbae393438c951ef3366fcefbe71e8d8b746b55daeeb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e1337613c632f412c15120e2700d54b41d89923be4225014b27303bcbd050bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72fce7ed955ed81c0d3d7341dcdb62dcf1f5be3c49ed9d499d895ac257112f3b"
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
