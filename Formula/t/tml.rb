class Tml < Formula
  desc "Tiny markup language for terminal output"
  homepage "https://github.com/liamg/tml"
  url "https://github.com/liamg/tml/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "68a87626aeba0859c39eebfe96d40db2d39615865bfe55e819feda3c7c9e1824"
  license "MIT"
  head "https://github.com/liamg/tml.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/liamg/tml/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./tml"
  end

  test do
    output = pipe_output("#{bin}/tml", "<green>not red</green>", 0)
    assert_match "\e[0m\e[32mnot red\e[39m\e[0m", output
  end
end
