class Sls < Formula
  desc "Fuzzy CLI selector for SSH config hosts"
  homepage "https://github.com/JinmuGo/sls"
  url "https://github.com/JinmuGo/sls/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "4f47b7d4934aecde5f415c4273898ebe1bebae9401129a16d65f9a259fe32882"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2da4027c34509c9ec1435bf5a90985c1c1c81197c3e767db8a742f10bf64b94d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2da4027c34509c9ec1435bf5a90985c1c1c81197c3e767db8a742f10bf64b94d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2da4027c34509c9ec1435bf5a90985c1c1c81197c3e767db8a742f10bf64b94d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71fb977c32a4f1108b22db565dbd8e87f2802ae771a206b456da1b1a2c2091e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49467ad91834d4907f72c60a2442b259b2acbe222929f579daca4ff063013d52"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s
      -w
      -X github.com/jinmugo/sls/cmd.version=#{version}
      -X github.com/jinmugo/sls/cmd.commit=Homebrew
      -X github.com/jinmugo/sls/cmd.date=unknown
      -X github.com/jinmugo/sls/cmd.builtBy=Homebrew
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"sls")
    generate_completions_from_executable(bin/"sls", shell_parameter_format: :cobra)
  end

  test do
    ssh_dir = testpath/".ssh"
    ssh_dir.mkpath
    (ssh_dir/"config").write <<~CONFIG
      Host demo
          HostName example.com
          User alice
          Port 2222
    CONFIG

    assert_equal "demo", shell_output("#{bin}/sls config list").strip
    assert_match version.to_s, shell_output("#{bin}/sls version")
  end
end
