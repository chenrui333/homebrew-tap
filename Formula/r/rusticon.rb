class Rusticon < Formula
  desc "Mouse driven SVG favicon editor for your terminal"
  homepage "https://github.com/ronilan/rusticon"
  url "https://github.com/ronilan/rusticon/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "afd41b39d965d9d0fd8d2c8dc4c1e82a453ffa83c3a8c6f031c15918f790e5af"
  license "CC-BY-NC-ND-4.0"
  head "https://github.com/ronilan/rusticon.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases do |json, regex|
      json.filter_map do |release|
        next if release["draft"] || release["prerelease"]

        match = release["tag_name"]&.match(regex)
        next if match.blank? || match[1] == "0.3.0" # Private git dependency prevents a source build

        match[1]
      end
    end
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd735e7d2fabb0b21c55b317a6affb2e8b7de2dc796f01f0341e5ac1f19773f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e50e0f5ae52af8e345a12da16f7da7d99d42b2b7b14b2939b3a4933ed2d05f3d"
    sha256 cellar: :any,                 arm64_linux:   "29c8447832a38fb28d5db666e7af569279fe270c08f04d46d2d3842704b5f5cd"
    sha256 cellar: :any,                 x86_64_linux:  "d54e4ce02e72464cde95f387918eb961cadd10b1ba826f421b09773eb15b4535"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Fails in Linux CI with `No such device or address` error
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"rusticon", testpath, [:out, :err] => output_log.to_s
      sleep 1
      assert_match "An icon editor for the terminal", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
