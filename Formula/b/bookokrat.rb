class Bookokrat < Formula
  desc "Terminal EPUB Book Reader"
  homepage "https://bugzmanov.github.io/bookokrat/index.html"
  url "https://github.com/bugzmanov/bookokrat/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "980678dc85b6b401e1c53be86eeb98a0b9da076155946d6d5a4b59eccc9c7e5f"
  license "MIT"
  head "https://github.com/bugzmanov/bookokrat.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Fails in Linux CI with `No such device or address (os error 6)` error
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      pid = spawn bin/"bookokrat"
      sleep 2
      assert_path_exists testpath/".bookokrat_settings.yaml"
      assert_match "Starting Bookokrat EPUB reader", (testpath/"bookokrat.log").read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
