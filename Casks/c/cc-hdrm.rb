cask "cc-hdrm" do
  version "1.5.1"
  sha256 "8c72cde7aaa2f744757f04ba9a9b593549965f68b5abe7c7cf7f0ba514543047"

  url "https://github.com/rajish/cc-hdrm/releases/download/v#{version}/cc-hdrm-#{version}.dmg"
  name "cc-hdrm"
  desc "Menu bar utility showing Claude subscription session headroom"
  homepage "https://github.com/rajish/cc-hdrm"

  livecheck do
    url :url
    strategy :github_latest
  end

  disable! date: "2026-09-01", because: :fails_gatekeeper_check

  depends_on macos: :sonoma

  app "cc-hdrm.app"

  zap trash: [
    "~/Library/Application Support/cc-hdrm",
    "~/Library/Caches/com.cc-hdrm.app",
    "~/Library/HTTPStorages/com.cc-hdrm.app",
  ]
end
