class Splashboard < Formula
  desc "Customizable terminal splash screen with plugin-based data sources"
  homepage "https://github.com/unhappychoice/splashboard"
  url "https://github.com/unhappychoice/splashboard/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "e00c67f429d58f36975d933114b6f083e9d4640b7348641ae8e0678987a8de51"
  license "ISC"
  head "https://github.com/unhappychoice/splashboard.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1144ba3201b5ffb2b9c207878bba7ea6437dcf2245f5b758035f65559f4e2e34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68887406d3045fcefbde3936d657520e1f11c6d0b6d1cc7bfbd67c9b1f9d87fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e52d81fe8c99a758a358a08a4eb628663ff2a81f18ceeea358319adcbf055fdf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6db89a7a3f605226ce6d862e85bd513cba607ddefe7d9a06825bb0895321387"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eca4ebaf151f0a66b067de28420052b9fe2057da6d5e304af7b198606febd875"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splashboard --version 2>&1")
  end
end
