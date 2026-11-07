(* Deploy the certificate once this kernel is signed into Wolfram Cloud. *)
(* wolframscript -file publish_cloud.wls -cloud *)
base = DirectoryName[$InputFileName];
results = Get[FileNameJoin[{base, "run_all_validations.wls"}]];

If[$CloudConnected,
  url = CloudDeploy[
    Delayed[results],
    "lightfoot-math-certificate",
    Permissions -> "Public"
  ];
  Print["Published: ", url];
  url,
  Print["Wolfram Cloud is not signed in. The scripts in this folder are ready to upload."];
  results
]
