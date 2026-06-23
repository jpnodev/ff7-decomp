// Imports custom symbols and function signatures from C files back into Ghidra
// @category Import
// @author Antigravity (AI Pair Programmer)

import ghidra.app.script.GhidraScript;
import ghidra.program.model.symbol.*;
import ghidra.program.model.address.Address;
import ghidra.program.model.listing.*;
import ghidra.program.model.data.FunctionDefinition;
import ghidra.program.model.data.ParameterDefinition;
import ghidra.app.services.DataTypeManagerService;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class ImportSplatSymbols extends GhidraScript {

    private int importSyms(File file) throws Exception {
        if (!file.exists()) {
            println("File not found: " + file.getAbsolutePath());
            return 0;
        }

        println("Importing from: " + file.getAbsolutePath());
        SymbolTable symbolTable = currentProgram.getSymbolTable();
        int count = 0;

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty() || line.startsWith("#") || line.startsWith("//")) {
                    continue;
                }
                if (line.contains("=")) {
                    String[] parts = line.split("=");
                    String name = parts[0].trim();
                    String addrStr = parts[1].split(";")[0].trim();
                    try {
                        long addrVal = Long.decode(addrStr);
                        Address addr = toAddr(addrVal);

                        if (applyRename(addr, name, symbolTable)) {
                            count++;
                        }
                    } catch (Exception e) {
                        println("Error processing line '" + line + "': " + e.getMessage());
                    }
                }
            }
        }
        println("Done importing from " + file.getName() + ": " + count + " symbols updated/created.");
        return count;
    }

    private int importMap(File file) throws Exception {
        if (!file.exists()) {
            println("Map file not found: " + file.getAbsolutePath());
            return 0;
        }

        println("Importing from map file: " + file.getAbsolutePath());
        SymbolTable symbolTable = currentProgram.getSymbolTable();
        int count = 0;

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty()) {
                    continue;
                }
                String[] parts = line.split("\\s+");
                if (parts.length >= 2) {
                    String addrStr = parts[0];
                    String name = parts[1];
                    if (addrStr.startsWith("0x80") && addrStr.length() == 10) {
                        if (name.matches("[a-zA-Z_][a-zA-Z0-9_]*")) {
                            // Filter out linker-script variables and other noise
                            if (name.equals("pgm") || name.equals("Linker") || name.equals("offset") || 
                                name.equals("type") || name.equals("size") || name.equals("ALIGN")) {
                                continue;
                            }
                            try {
                                long addrVal = Long.decode(addrStr);
                                Address addr = toAddr(addrVal);

                                if (applyRename(addr, name, symbolTable)) {
                                    count++;
                                }
                            } catch (Exception e) {
                                // Ignore parsing errors for non-hex values in map
                            }
                        }
                    }
                }
            }
        }
        println("Done importing map file: " + count + " symbols updated/created.");
        return count;
    }

    private boolean applyRename(Address addr, String name, SymbolTable symbolTable) throws Exception {
        // 1. Try to rename function if one exists at this address
        Function func = currentProgram.getFunctionManager().getFunctionAt(addr);
        if (func != null) {
            String oldName = func.getName();
            if (!oldName.equals(name)) {
                func.setName(name, SourceType.USER_DEFINED);
                println("Renamed function at " + addr + ": " + oldName + " -> " + name);
                return true;
            }
        } else {
            // 2. Try to rename/create a label
            Symbol[] existingSyms = symbolTable.getSymbols(addr);
            boolean done = false;
            for (Symbol s : existingSyms) {
                String oldName = s.getName();
                if (!oldName.equals(name)) {
                    s.setName(name, SourceType.USER_DEFINED);
                    println("Renamed symbol at " + addr + ": " + oldName + " -> " + name);
                    return true;
                }
                done = true;
                break;
            }
            if (!done) {
                symbolTable.createLabel(addr, name, SourceType.USER_DEFINED);
                println("Created label at " + addr + ": " + name);
                return true;
            }
        }
        return false;
    }

    private void importSignatures(File srcDir, File mapFile) throws Exception {
        if (!srcDir.exists() || !mapFile.exists()) {
            return;
        }
        println("Scanning C files in: " + srcDir.getAbsolutePath() + " to import signatures...");
        
        // 1. Parse map file to link function names to addresses
        java.util.Map<String, Address> funcAddresses = new java.util.HashMap<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(mapFile))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.trim().split("\\s+");
                if (parts.length >= 2) {
                    String addrStr = parts[0];
                    String name = parts[1];
                    if (addrStr.startsWith("0x80") && addrStr.length() == 10) {
                        if (name.matches("[a-zA-Z_][a-zA-Z0-9_]*")) {
                            try {
                                long addrVal = Long.decode(addrStr);
                                Address addr = toAddr(addrVal);
                                funcAddresses.put(name, addr);
                            } catch (Exception e) {}
                        }
                    }
                }
            }
        }

        // Get the DataTypeManagerService for parsing
        DataTypeManagerService service = state.getTool().getService(DataTypeManagerService.class);
        if (service == null) {
            println("Warning: DataTypeManagerService not found. Cannot parse signatures.");
            return;
        }

        // 2. Scan all C source files
        File[] files = srcDir.listFiles();
        if (files == null) return;
        
        ghidra.app.util.parser.FunctionSignatureParser sigParser = 
            new ghidra.app.util.parser.FunctionSignatureParser(currentProgram.getDataTypeManager(), service);
            
        int sigCount = 0;
        SymbolTable symbolTable = currentProgram.getSymbolTable();
        for (File f : files) {
            if (f.getName().endsWith(".c")) {
                String funcName = f.getName().substring(0, f.getName().length() - 2);
                Address addr = funcAddresses.get(funcName);
                if (addr == null) {
                    SymbolIterator symIter = symbolTable.getSymbols(funcName);
                    if (symIter.hasNext()) {
                        addr = symIter.next().getAddress();
                    }
                }
                
                if (addr != null) {
                    Function func = currentProgram.getFunctionManager().getFunctionAt(addr);
                    if (func != null) {
                        String sigStr = findSignatureInCFile(f, funcName);
                        if (sigStr != null) {
                            try {
                                // Parse C function signature string
                                FunctionDefinition def = sigParser.parse(null, sigStr);
                                
                                // Map ParameterDefinitions to ParameterImpl objects for Ghidra
                                ParameterDefinition[] argDefs = def.getArguments();
                                List<Parameter> params = new ArrayList<>();
                                for (ParameterDefinition d : argDefs) {
                                    params.add(new ParameterImpl(d.getName(), d.getDataType(), currentProgram));
                                }
                                
                                // Apply the signature return type and parameters
                                func.setReturnType(def.getReturnType(), SourceType.USER_DEFINED);
                                func.replaceParameters(
                                    params, 
                                    Function.FunctionUpdateType.DYNAMIC_STORAGE_ALL_PARAMS, 
                                    true, 
                                    SourceType.USER_DEFINED
                                );
                                println("Applied signature to function " + funcName + " at " + addr + ": " + sigStr);
                                sigCount++;
                            } catch (Exception e) {
                                println("Failed to parse/apply signature for " + funcName + " (" + sigStr + "): " + e.getMessage());
                            }
                        }
                    }
                }
            }
        }
        println("Done applying signatures: " + sigCount + " signatures updated.");
    }

    private String findSignatureInCFile(File f, String funcName) throws Exception {
        // Pattern: [return_type] funcName([args])
        Pattern p = Pattern.compile(
            "^\\s*([a-zA-Z_][a-zA-Z0-9_\\s\\*]*)\\s+" + Pattern.quote(funcName) + "\\s*\\(([^\\)]*)\\)"
        );
        try (BufferedReader reader = new BufferedReader(new FileReader(f))) {
            String line;
            while ((line = reader.readLine()) != null) {
                Matcher m = p.matcher(line);
                if (m.find()) {
                    return m.group(0).trim();
                }
            }
        }
        return null;
    }

    @Override
    protected void run() throws Exception {
        String baseDir;
        String[] args = getScriptArgs();
        
        if (args.length > 0) {
            baseDir = args[0];
        } else {
            File dir = askDirectory("Select ff7-decomp workspace root directory", "Select");
            if (dir == null) {
                println("Import cancelled.");
                return;
            }
            baseDir = dir.getAbsolutePath();
        }

        // 1. Load manual_syms.txt
        File manualSyms = new File(baseDir, "config/symbols/SCES_008.68.manual_syms.txt");
        importSyms(manualSyms);

        // 2. Load sys_syms.txt
        File sysSyms = new File(baseDir, "config/symbols/SCES_008.68.sys_syms.txt");
        importSyms(sysSyms);


        // 3. Load compiled map file if present (build/SCES_008.68.map)
        File mapFile = new File(baseDir, "build/SCES_008.68.map");
        importMap(mapFile);

        // 4. Scan C files and apply function signatures
        File srcDir = new File(baseDir, "src/SCES_008.68");
        importSignatures(srcDir, mapFile);
    }
}
