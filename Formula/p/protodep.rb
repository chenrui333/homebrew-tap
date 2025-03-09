class Protodep < Formula
  desc "Collect necessary .proto files (Protocol Buffers IDL) and manage dependencies"
  homepage "https://github.com/stormcat24/protodep"
  url "https://github.com/stormcat24/protodep/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "0dd26260f604955209c856c179e225cdc956fe7ba7f92f33a4f1d5d8d86d30aa"
  license "Apache-2.0"

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

    generate_completions_from_executable(bin/"protodep", "completion")
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
