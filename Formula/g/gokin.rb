class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.65.2.tar.gz"
  sha256 "ac25b149e784465625afb400d1fd2310f84519de03fe161129d8154cae60b26e"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ed51ed72339f7791136842c10acbaddff1801f6820ee01e8dc25aa74558f8fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ed51ed72339f7791136842c10acbaddff1801f6820ee01e8dc25aa74558f8fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ed51ed72339f7791136842c10acbaddff1801f6820ee01e8dc25aa74558f8fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e8d067f090357d68618b3aa45d8b05488346eb2d518d54f052f32f54dad1b94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9123c59538107061f121f6045dd811db06c703542b4da75dc372e0e398e249c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    assert_match "Available Commands:", shell_output("#{bin}/gokin --help")
  end
end
