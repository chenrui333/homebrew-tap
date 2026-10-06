class Pluqqy < Formula
  desc "Terminal-based context management for AI driven development"
  homepage "https://pluqqy.com/"
  url "https://github.com/pluqqy/pluqqy-terminal/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "ea69eefa597a87f715f57cfbee3cf82cb7cd8e74ba0517b8194affefa3a55e2f"
  license "MIT"
  head "https://github.com/pluqqy/pluqqy-terminal.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09faee36eba29375bf93ce28f8467490c980a9eb8bd6bda4c312e72752bf36d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09faee36eba29375bf93ce28f8467490c980a9eb8bd6bda4c312e72752bf36d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9916e08a153c61ca5b845db3447e41eaf7965546644797642782633980d20ddc"
    sha256 cellar: :any,                 x86_64_linux:  "c8f333d84d28a648c32e5c29fcc87520d4b5c4e337d9a170cf5c0de802a2854a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/pluqqy"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pluqqy version")

    output = shell_output("#{bin}/pluqqy init")
    assert_match "Initializing Pluqqy project in #{testpath}", output
    assert_path_exists testpath/".pluqqy"

    assert_match "No items found", shell_output("#{bin}/pluqqy list")
  end
end
