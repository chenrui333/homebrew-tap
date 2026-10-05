class Kcl < Formula
  desc "CLI for the KCL programming language"
  homepage "https://github.com/kcl-lang/cli"
  url "https://github.com/kcl-lang/cli/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "e2409675a52d0bd656c7f2aa16304c5a2622c5b969412020159676b9c1753093"
  license "Apache-2.0"
  head "https://github.com/kcl-lang/cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27d1adbbfc6c7fb06d6f1cfdab27e9f5005000382b9f9a842df2b8c9c658fda8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "629027d69aecd956b0e466dfb3fe74dedc5b060b178a5df82b7aa5401ab75c93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "382838fb5ac7b5066888837c82bd2ac3c5279747512c3a75a7dc757d67430b6f"
    sha256 cellar: :any,                 x86_64_linux:  "e88a5cebdd3a21435799f5cd0066205d04e122b90ea4f07bc7c244c3d70aff29"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X kcl-lang.io/cli/pkg/version.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kcl"

    generate_completions_from_executable(bin/"kcl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kcl --version")

    (testpath/"test.k").write <<~EOS
      hello = "KCL"
    EOS
    assert_equal "hello: KCL", shell_output("#{bin}/kcl run #{testpath}/test.k").chomp
  end
end
