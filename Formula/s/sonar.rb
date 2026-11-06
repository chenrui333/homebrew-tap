class Sonar < Formula
  desc "CLI tool for inspecting and managing localhost ports"
  homepage "https://github.com/raskrebs/sonar"
  url "https://github.com/raskrebs/sonar/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "a2667f862f8b5850c065d02f51101b48af6b4d687cd839ffdccce1c4299cf915"
  license "MIT"
  head "https://github.com/raskrebs/sonar.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85648dd87b3cf1602549ecd48c122ceaf4827a42d72401968fc28d8433e12017"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85648dd87b3cf1602549ecd48c122ceaf4827a42d72401968fc28d8433e12017"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1d7a061645522a10463ad28653ae8f8b8dfa844f36da7e8937731db8b208963"
    sha256 cellar: :any,                 x86_64_linux:  "d725170fecd2a5e15b77db1847328d631246a28fcef81ad0cfaa589de193cff6"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "iproute2" # port scanning shells out to `ss`
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X github.com/raskrebs/sonar/internal/selfupdate.Version=v#{version}"

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"sonar",
                                         shell_parameter_format: :cobra,
                                         shells:                 [:bash, :zsh, :fish])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sonar version")

    output = shell_output("#{bin}/sonar init --no-daemon --service web:3000 2>&1")
    assert_match "with 1 service", output
    assert_match "port: 3000", (testpath/"sonar.yaml").read

    output = shell_output("#{bin}/sonar init --no-daemon --service web:3000 2>&1", 1)
    assert_match "sonar.yaml already exists", output
  end
end
