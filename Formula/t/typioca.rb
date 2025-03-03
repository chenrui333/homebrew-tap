class Typioca < Formula
  desc "Cozy typing speed tester in terminal"
  homepage "https://github.com/bloznelis/typioca"
  url "https://github.com/bloznelis/typioca/archive/refs/tags/3.1.0.tar.gz"
  sha256 "b58dfd36e9f23054b96cbd5859d1a93bc8d3f22b4ce4fd16546c9f19fc4a003c"
  license "MIT"
  head "https://github.com/bloznelis/typioca.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00a8e1dbde4769d5fb80685f217b638ad8aa706e4a984f78731d2541920376e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdb2c308dec9a278bf95a68e59ca983bcbe0c36a74d28d4f773329a2943dcd59"
    sha256 cellar: :any_skip_relocation, ventura:       "211d7cca63118f93422131cba47070ad37ba6c6a6b818ffaf2e9c8a84bc3bee3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a9e3c58d54a4ddfbb78dbf8dcdf7264cc70ba3ee05788038bab444e1c0948f4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/bloznelis/typioca/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"typioca", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/typioca --version")

    pid = spawn bin/"typioca", "serve"
    sleep 1
    assert_path_exists testpath/"typioca"
    assert_path_exists testpath/"typioca.pub"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
