class Pluqqy < Formula
  desc "Terminal-based context management for AI driven development"
  homepage "https://pluqqy.com/"
  url "https://github.com/pluqqy/pluqqy-terminal/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "ea69eefa597a87f715f57cfbee3cf82cb7cd8e74ba0517b8194affefa3a55e2f"
  license "MIT"
  head "https://github.com/pluqqy/pluqqy-terminal.git", branch: "main"

  depends_on "go" => :build

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
